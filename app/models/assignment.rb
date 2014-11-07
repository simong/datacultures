class Assignment < ActiveRecord::Base

  acts_as_paranoid


  def self.canvas_assignments
    select(:canvas_assignment_id, :name).map(&:serializable_hash)
  end

  def self.sync_if_needed(assignments_data:)
    assignment_ids = self.canvas_assignments.map{|a| a['canvas_assignment_id']}
    assignments_data.each do |assignment_data|
      if !(assignment_ids.include? (assignment_data['id']))
        Assignment.create({name: assignment_data['name'],
                          canvas_assignment_id: assignment_data['id']})
      end
    end
  end

end
