import ddf.minim.*;
import ddf.minim.analysis.*;

static final boolean VISIBLE = true;
static final int BUFFER_SIZE = 2048;
static final float DECAY_RATE = 0.75;

Minim minim;
AudioInput in;
WaveListener wl;

int amplitude = 4096;
float[] samples = new float[BUFFER_SIZE];


class WaveListener implements AudioListener
{
  private AudioInput source;
  private float[] samples;
  private float[] samplesL;
  private float[] samplesR;


  WaveListener(AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    samples  = new float[this.source.bufferSize()];
    samplesL = new float[this.source.bufferSize()];
    samplesR = new float[this.source.bufferSize()];
  }

  void samples(float[] samples)
  {
    this.samples = samples;
  }

  void samples(float[] samplesL, float[] samplesR)
  {
    this.samplesL = samplesL;
    this.samplesR = samplesR;
  }

  float[] getSamples()
  {
    return samples;
  }
  float[] getSamplesL()
  {
    return samplesL;
  }
  float[] getSamplesR()
  {
    return samplesR;
  }
}

void setup()
{
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, BUFFER_SIZE);
  wl = new WaveListener(in);

  size(BUFFER_SIZE, 1080, P3D);

}

void draw()
{
  background(0);
  
  stroke(255);

  for(int i = 0; i < BUFFER_SIZE; i++)
  {
    float currentSample = wl.getSamplesL()[i];
    if (samples[i] < currentSample)
      samples[i] = currentSample;

    rect(i, height, 1, -samples[i]*amplitude);

    samples[i] *= DECAY_RATE;
  }

  text("Amplitude: "+amplitude, 300, 24);
}

void mouseMoved()
{
  amplitude = (int)map( mouseY, 0, height, 16384, 1024);
}
 
void stop()
{
  // always close Minim audio classes when you are finished with them
  in.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
} 

boolean displayable() { 
  return VISIBLE; 
}