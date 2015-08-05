import ddf.minim.*;
import ddf.minim.analysis.*;

static final boolean VISIBLE = true;
static final int BUFFER_SIZE = 2048;
static final float DECAY_RATE = 0.75;

Minim minim;
AudioInput in;
FFT fft;

int amplitude = 32;
float[] samples;

class FrequencyListener implements AudioListener
{
  private FFT fft;
  private AudioInput source;

  FrequencyListener(FFT fft, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.fft = fft;
  }

  void samples(float[] samples)
  {
    fft.forward(source.mix);
  }

  void samples(float[] samplesL, float[] samplesR)
  {
    fft.forward(source.mix);
  }
}

void setup()
{
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, BUFFER_SIZE);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  new FrequencyListener(fft, in);

  samples = new float[fft.specSize()];
  size(fft.specSize(), 1080, P3D);

}

void draw()
{
  background(0);

  stroke(255);
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    float currentBand = fft.getBand(i);
    if (samples[i] < currentBand)
      samples[i] = currentBand;

    rect(i, height, 1, -samples[i]*amplitude);

    samples[i] *= DECAY_RATE;
  }

  text("Amplitude: "+amplitude, 300, 24);
}

void mouseMoved()
{
  amplitude = (int)map( mouseY, 0, height, 512, 8);
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