// need to import this so we can use Mixer and Mixer.Info objects
import javax.sound.sampled.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
SelectInput si;
int currentInput;

class SelectInput
{
  private Minim minim;
  private Mixer mixer;

  private Mixer.Info[] mixerInfo;
  private Mixer.Info[] usableInputs;
  private int usableInputsSize = 0;

  SelectInput()
  {
    AudioInput in;
    minim = new Minim(this);
    mixerInfo = AudioSystem.getMixerInfo();
    Mixer.Info[] usableInputs_temp = new Mixer.Info[mixerInfo.length];

    for(int i = 0; i < mixerInfo.length; i++)
    {
      boolean passed = true;
      try
      {
        // Set the i-th input and try getting data from it.
        mixer = AudioSystem.getMixer(mixerInfo[i]);
        minim.setInputMixer(mixer);
        in = minim.getLineIn(Minim.STEREO);
        // (we try to pull some data from the input,
        //  this is what crashes invalid inputs)
        in.left.get(0);
      } 
      catch (Exception e)
      {
        // If it crashes, we cannot use it.
        passed = false;
      }
      // But if it doesn't, then we can.
      if (passed) usableInputs_temp[usableInputsSize++] = mixerInfo[i];
    }

    usableInputs = new Mixer.Info[usableInputsSize];
    System.arraycopy(usableInputs_temp, 0, usableInputs, 0, usableInputsSize);
  }

  Mixer.Info[] getInputs()
  {
    return usableInputs;
  }

  AudioInput setInput(Mixer.Info mixerInfoElement)
  {
    mixer = AudioSystem.getMixer(mixerInfoElement);
    minim.setInputMixer(mixer);
    return minim.getLineIn(Minim.STEREO);
  }
}

void setup()
{
  minim = new Minim(this);
  si = new SelectInput();

  // In this example, we will look for the Soundflower (2ch)
  // input and set it if it's available.

  // First we will set a default index, in case we don't find it.
  currentInput = 0;
  // Next we will search for the input with the matching name.
  for (int i = 0; i < si.getInputs().length; i++)
    if(si.getInputs()[i].getName().equals("Soundflower (2ch)"))
      currentInput = i;
  // Now we set the input. If soundflower was found it should be set.
  in = si.setInput(si.getInputs()[currentInput]);
 
  size(512, 200, P3D);
}

void draw()
{
  background(0);
  stroke(255);
  
  // This is taken from the Minim -> MonitorInput example sketch
  // It's just to show you if sound is playing.
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line( i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50 );
    line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }

  text("Press space to switch inputs:\n" + si.getInputs()[currentInput%(si.getInputs().length)], 0, 12);
}

void keyPressed()
{
  if ( key == ' ' )
    in = si.setInput(si.getInputs()[(++currentInput)%(si.getInputs().length)]);
}