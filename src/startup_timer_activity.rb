require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :ImageView, :LinearLayout, :TextView

java_import android.view.Gravity

class StartupTimerActivity
  include Ruboto::Activity

  def on_create(bundle)
    set_title "Ruboto startup timer #{package_manager.getPackageInfo($package_name, 0).versionName}"

    self.content_view =
        linear_layout :orientation => :vertical, :gravity => Gravity::CENTER do
          image_view :image_resource => $package::R::drawable::icon, :scale_type => ImageView::ScaleType::FIT_CENTER,
                     :layout         => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
          @text_view     = text_view :text    => "", :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20],
                                     :gravity => Gravity::CENTER, :id => 42,
                                     :layout  => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent}
          @report_button = button :text              => 'Report', :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20],
                                  :id                => 43, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent},
                                  :on_click_listener => proc { |view| handle_click(view) }
          @exit_button   = button :text => 'Exit', :text_size => [Java::android.util.TypedValue::COMPLEX_UNIT_PT, 20],
                                  :id   => 44, :layout => {:weight= => 1, :height= => :fill_parent, :width= => :fill_parent},
                                  :on_click_listener => proc { |view| handle_click(view) }
        end
  end

  def on_resume
    $package.StartupTimerActivity.stop ||= java.lang.System.currentTimeMillis
    @startup_time                      ||= $package.StartupTimerActivity.stop - $package.StartupTimerActivity::START
    @text_view.text                    = "Startup took #{@startup_time} ms"
  end

  private

  def handle_click(view)
    case view
    when @report_button
      java_import android.content.Intent
      java_import android.net.Uri
      java_import android.util.Log

      require 'report'
      Report.send_report(self, true, @startup_time)
    when @exit_button
      finish
      java.lang.System.runFinalizersOnExit(true)
      java.lang.System.exit(0)
    end
  end

end
