namespace :git do
  task :init do
    begin
      require 'grit'
    rescue LoadError
      puts "Oops!"
      puts "sudo gem install grit"
    end
    require 'pathname'
    @repo = Grit::Repo.new RAILS_ROOT
    @run = !ENV['RUN'].nil?

    @status = `git status`.split("\n")
    @git_branch = `git branch`.split("\n")
    ENV['MASTER'] ||= 'master'
    @git_branch.each { |b| ENV['BRANCH'] = b[2..-1] if b[0..0] == '*' } unless ENV['BRANCH']
    raise "Need a branch name: BRANCH=mychanges" unless ENV['BRANCH']
    @master, @branch = filter_migrations ENV['MASTER'], ENV['BRANCH']
    unless @status.any? { |s| s =~ /^# On branch #{ENV['BRANCH']}/ }
      puts "Hey, you're not on the #{ENV['BRANCH'].inspect} branch, what are you trying to pull anyway?"
      puts
      puts @git_branch
      exit
    end
    unless @status.any? { |s| s =~ /\(working directory clean\)/ }
      puts "Hey, your working directory isn't clean, what are you trying to pull anyway?"
      puts
      puts @status
      exit
    end
  end

  task :rebase_migrations => :init do
    if @master.empty?
      puts "No new migrations in #{ENV['MASTER'].inspect}"
      if @branch.empty?
        puts "No new migrations in #{ENV['BRANCH'].inspect} either, you're clear!"
      else
        puts "#{@branch.size} new migration(s) in #{ENV['BRANCH'].inspect}: #{@branch.inspect}."
        puts "You should 'rake db:migrate VERSION=#{lowest_migration_number(@branch) - 1}' before merging with #{ENV['MASTER'].inspect}"
      end
    else
      puts "#{@master.size} new migration(s) in #{ENV['MASTER'].inspect}: #{@master.inspect}."
      if @branch.empty?
        puts "No new migrations in #{ENV['BRANCH'].inspect}.  Just remember to 'rake db:migrate' AFTER merging with #{ENV['MASTER'].inspect}."
      else
        operations = renumber_migrations_with_offset(@branch, @master.size)
        puts "#{@branch.size} new migration(s) in #{ENV['BRANCH'].inspect}: #{@branch.inspect}."
        puts
        puts "#{'Suggested ' unless @run}Renumbering..."
        root = Pathname.new(RAILS_ROOT)
        migrate = root + 'db/migrate'
        operations.sort_by { |(old, new)| old }.each do |(old, new)|
          cmd = "git mv #{(migrate + old).relative_path_from(root)} #{(migrate + new).relative_path_from(root)}"
          puts cmd
          system cmd if @run
        end
        puts
        if @run
          puts "Migrations rebased!  Next actions:"
          puts " rake db:migrate VERSION=#{lowest_migration_number(@branch) - 1}"
          puts " git commit -m '...'"
          puts " git checkout #{ENV['MASTER']}"
          puts " git merge #{ENV['BRANCH']}"
          puts " rake db:migrate"
          puts
          puts 'Have a nice day!'
        else
          puts "Run with RUN=1 to actually rename the files."
        end
      end
    end
  end
  
  def lowest_migration_number(migrations)
    migrations.collect { |m| m.to_i }.min
  end
  
  def renumber_migrations_with_offset(migrations, offset)
    migrations.inject({}) do |hash, m|
      num, *base = m.split("_")
      base.unshift "%03d" % (num.to_i + offset)
      hash.update m => base.join("_")
    end
  end
  
  def migrations_for(branch_name)
    head = @repo.tree(branch_name)
    tree = head / 'db' / 'migrate'
    tree.contents.collect { |c| c.name }.delete_if { |n| n !~ /^\d+_[^\.]+.rb$/ }.sort
  rescue
    puts "Trouble with the #{branch_name} branch..."
    raise
  end
  
  def filter_migrations(master, branch)
    master_migrations = migrations_for(master)
    branch_migrations = migrations_for(branch)
    common = master_migrations & branch_migrations
    [master_migrations - common, branch_migrations - common]
  end
end