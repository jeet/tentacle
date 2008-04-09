# Friends
module Friends
  module ClassMethods
    def can_befriend
      class_eval do
        has_many :approved_friendships, :class_name  => "Friendship", :foreign_key => 'requester_id=#{id} OR requested_id', :conditions => 'approved = #{Friendship::APPROVED}'
        has_many :follower_friends, :class_name => "Friendship", :foreign_key => "requested_id", :conditions => 'approved = #{Friendship::PENDING}'
        has_many :following_friends, :class_name => "Friendship", :foreign_key => "requester_id", :conditions => 'approved = #{Friendship::PENDING}'

        has_many :friends,   :through => :approved_friendships, :source => :requested
        has_many :followers, :through => :follower_friends, :source => :requester
        has_many :followings, :through => :following_friends, :source => :requested
        
        include InstanceMethods
      end
    end
    
    def can_follow
      class_eval do
        has_many :follower_friends, :class_name => "Friendship", :foreign_key => "requested_id", :conditions => 'approved = 0'
        has_many :following_friends, :class_name => "Friendship", :foreign_key => "requester_id", :conditions => 'approved = 0'
        has_many :approved_friendships, :class_name => "Friendship", :finder_sql => 'SELECT * FROM friendships WHERE ((requester_id = #{id}) OR (requested_id = #{id}) AND (approved = 0))', :uniq => true
        
        has_many :followers, :through => :follower_friends, :source => :requester
        has_many :followings, :through => :following_friends, :source => :requested
        has_many :friends, :class_name => "Profile", :finder_sql => 'SELECT * FROM profiles INNER JOIN friendships ON ((profiles.id = friendships.requested_id) OR (profiles.id = friendships.requester_id)) AND profiles.id != #{id} WHERE (((friendships.requester_id = #{id}) OR (friendships.requested_id = #{id})) AND ((approved = 1)))'
        
        const_set("Friendship", Class.new(ActiveRecord::Base)).class_eval("""
          set_table_name 'friendships'
          
          belongs_to :requester, :class_name => '#{name}'
          belongs_to :requested, :class_name => '#{name}'
          
          def approve!
            self.approved = true
            save!
          end

          def unfriend!
            destroy
          end
        """)
        
        include InstanceMethods
      end
    end
  end
  
  module InstanceMethods
    def request_friendship_with(user)
      Friendship.create(:requested_id => user.id, :requester_id => id, :approved => false)
    end
  end
end