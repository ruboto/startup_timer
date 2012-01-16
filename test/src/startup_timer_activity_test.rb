activity Java::org.ruboto.startup_timer.StartupTimerActivity

setup do |activity|
  start = Time.now
  loop do
    @text_view = activity.findViewById(42)
    break if @text_view || (Time.now - start > 60)
    sleep 1
  end
  assert @text_view
end

test('initial setup') do |activity|
  assert_matches /Startup took \d+ ms/, @text_view.text
end
