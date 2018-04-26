require "test_helper"

class SnapshotsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get snapshots_show_url
    assert_response :success
  end

  test "should get create" do
    get snapshots_create_url
    assert_response :success
  end

  test "should get update" do
    get snapshots_update_url
    assert_response :success
  end

  test "should get destroy" do
    get snapshots_destroy_url
    assert_response :success
  end
end
