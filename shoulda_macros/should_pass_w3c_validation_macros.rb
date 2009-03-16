require 'w3c_validators'

module ShouldPassW3cValidationMacros
  include W3CValidators
  
  def should_pass_w3c_validation
    should "pass w3c validation" do
      tempfile = Tempfile.new('test')
      tempfile.write(@response.body)
      tempfile.flush
      
      sleep 0.5 # Take a nap
      
      validator = MarkupValidator.new
      results = validator.validate_file(tempfile.path)
      valid = [results.errors, results.warnings].all?{ |set| set.size == 0 }
      fail_text = ''
      unless valid
        fail_text = (results.errors + results.warnings).inject('') do |text, message| 
          message = message.to_s.sub(/URI:[^;]+;/, '')
          text << "\n#{message}"
        end
      end
      assert valid, fail_text
    end  
  end
end

class ActionController::TestCase
  extend ShouldPassW3cValidationMacros
end