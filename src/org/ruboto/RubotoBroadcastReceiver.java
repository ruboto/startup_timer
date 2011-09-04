package org.ruboto;

import java.io.IOException;

public abstract class RubotoBroadcastReceiver extends android.content.BroadcastReceiver {
    private String scriptName;
    private String remoteVariable = "";

  public static final int CB_RECEIVE = 0;

    private Object[] callbackProcs = new Object[1];

    public void setCallbackProc(int id, Object obj) {
        callbackProcs[id] = obj;
    }
	
    public RubotoBroadcastReceiver setRemoteVariable(String var) {
        remoteVariable = ((var == null) ? "" : (var + "."));
        return this;
    }

    public void setScriptName(String name){
        scriptName = name;
    }

    public RubotoBroadcastReceiver(String scriptName) {
        setScriptName(scriptName);
        Script.defineGlobalVariable("$broadcast_receiver", this);
        try {
            new Script(scriptName).execute();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }

    /****************************************************************************************
     * 
     *  Generated Methods
     */

  public void onReceive(android.content.Context context, android.content.Intent intent) {
    if (callbackProcs[CB_RECEIVE] != null) {
      Script.callMethod(callbackProcs[CB_RECEIVE], "call" , new Object[]{context, intent});
    }
  }

}	


