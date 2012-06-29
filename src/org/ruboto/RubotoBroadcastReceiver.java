package org.ruboto;

import java.io.IOException;

public class RubotoBroadcastReceiver extends android.content.BroadcastReceiver {
    private String scriptName = null;
    private Object rubyInstance;

    public void setCallbackProc(int id, Object obj) {
        // Error: no callbacks
        throw new RuntimeException("RubotoBroadcastReceiver does not accept callbacks");
    }
	
    public void setScriptName(String name){
        scriptName = name;
    }

    public RubotoBroadcastReceiver() {
        this(null);
    }

    public RubotoBroadcastReceiver(String name) {
        super();

        if (name != null) {
            setScriptName(name);
        
            if (Script.isInitialized()) {
                loadScript();
            }
        }
    }

    protected void loadScript() {
        Script.put("$broadcast_receiver", this);
        if (scriptName != null) {
            try {
                new Script(scriptName).execute();
                String rubyClassName = Script.toCamelCase(scriptName);
                System.out.println("Looking for Ruby class: " + rubyClassName);
                Object rubyClass = Script.get(rubyClassName);
                if (rubyClass != null) {
                    System.out.println("Instanciating Ruby class: " + rubyClassName);
                    Script.put("$java_broadcast_receiver", this);
                    Script.exec("$ruby_broadcast_receiver = " + rubyClassName + ".new($java_broadcast_receiver)");
                    rubyInstance = Script.get("$ruby_broadcast_receiver");
                }
            } catch(IOException e) {
                throw new RuntimeException("IOException loading broadcast receiver script", e);
            }
        }
    }

    public void onReceive(android.content.Context context, android.content.Intent intent) {
        try {
            System.out.println("onReceive: " + rubyInstance);
            Script.put("$context", context);
            Script.put("$broadcast_receiver", this);
            Script.put("$intent", intent);
            if (rubyInstance != null) {
                Script.exec("$ruby_broadcast_receiver.on_receive($context, $intent)");
            } else {
                Script.execute("$broadcast_receiver.on_receive($context, $intent)");
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}	


