require "test_helper"

class WorkLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get work_logs_index_url
    assert_response :success
  end
end
