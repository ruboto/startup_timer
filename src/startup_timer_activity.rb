require 'ruboto'

WITH_IMAGE = rand(2) == 0

if WITH_IMAGE
  ruboto_import_widgets :Button, :ImageView, :LinearLayout, :TextView
else
  ruboto_import_widgets :Button, :LinearLayout, :TextView
end

java_import android.view.Gravity

$activity.handle_create do |bundle|
  setTitle "Ruboto startup timer #{package_manager.getPackageInfo($package_name, 0).versionName}"

  setup_content do
    linear_layout :orientation => :vertical, :gravity => Gravity::CENTER do
      if WITH_IMAGE
        image_view :image_resource => $package::R::drawable::icon, :scale_type => ImageView::ScaleType::FIT_CENTER, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
      end
      @text_view = text_view :text => "", :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20], :gravity => Gravity::CENTER, :id => 42, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
      @report_button = button :text => 'Report', :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20], :id => 43, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
      @exit_button = button :text => 'Exit', :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20], :id => 44, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
    end
  end

  handle_click do |view|
    case view
    when @report_button
      java_import android.content.Intent
      java_import android.net.Uri
      java_import android.util.Log

      require 'report'
      Report.send_report(self, WITH_IMAGE, @startup_time)
    when @exit_button
      finish
      java.lang.System.runFinalizersOnExit(true)
      java.lang.System.exit(0)
    end
  end

  handle_resume do
    $package.StartupTimerActivity.stop ||= java.lang.System.currentTimeMillis
    @startup_time ||= $package.StartupTimerActivity.stop - $package.StartupTimerActivity::START
    @text_view.text = "Startup took #{@startup_time} ms"
  end

end
