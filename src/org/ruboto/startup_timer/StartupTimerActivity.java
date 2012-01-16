package org.ruboto.startup_timer;

import android.os.Bundle;

public class StartupTimerActivity extends org.ruboto.EntryPointActivity {
    public static final long START = System.currentTimeMillis();
    public static Long stop;

	public void onCreate(Bundle bundle) {
		setScriptName("startup_timer_activity.rb");
	    super.onCreate(bundle);
	}
}
