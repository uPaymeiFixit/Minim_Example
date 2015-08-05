import ddf.minim.*;
import ddf.minim.analysis.*;

static final boolean VISIBLE = true;
static final int BUFFER_SIZE = 2048;
static final float DECAY_RATE = 0.9;
static final int MAX_RADIUS = 75;
static final int MIN_RADIUS = 20;


Minim minim;
AudioInput in;
BeatDetect beat;

float radius_Hat;
float radius_Kick;
float[] radius_Onset;
float radius_Range;
float radius_Snare;

int sensitivity = 10; // 10ms is the default BeatDetect sensitivity
int num_bands = 0;
int range_value = 1;



// This class adds a listener to the AudioInput, so we don't
// need to keep calling beat.detect(). This makes sure we do
// not have any overlap in the buffer we receive.
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;
  
  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup()
{
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, BUFFER_SIZE);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  new BeatListener(beat, in);

  // number of frequency bands being used
  num_bands = beat.dectectSize();
  radius_Onset = new float[num_bands];
  size(MAX_RADIUS*num_bands, MAX_RADIUS*5, P3D);
}

void draw()
{
  background(0);

  // Detect beat variants and calculate radius
  if ( beat.isHat() ) radius_Hat = MAX_RADIUS;
  else radius_Hat *= DECAY_RATE;
  if ( radius_Hat < MIN_RADIUS ) radius_Hat = MIN_RADIUS;

  if ( beat.isKick() ) radius_Kick = MAX_RADIUS;
  else radius_Kick *= DECAY_RATE;
  if ( radius_Kick < MIN_RADIUS ) radius_Kick = MIN_RADIUS;

  for (int i = 0; i < num_bands; i++)
  {
    if ( beat.isOnset(i) ) radius_Onset[i] = MAX_RADIUS;
    else radius_Onset[i] *= DECAY_RATE;
    if ( radius_Onset[i] < MIN_RADIUS ) radius_Onset[i] = MIN_RADIUS;
  }

  if ( beat.isRange(0, num_bands-1, range_value) ) radius_Range = MAX_RADIUS;
  else radius_Range *= DECAY_RATE;
  if ( radius_Range < MIN_RADIUS ) radius_Range = MIN_RADIUS;

  if ( beat.isSnare() ) radius_Snare = MAX_RADIUS;
  else radius_Snare *= DECAY_RATE;
  if ( radius_Snare < MIN_RADIUS ) radius_Snare = MIN_RADIUS;


  // Draw circles
  fill(255,   0,   0);
   ellipse(MAX_RADIUS/2, MAX_RADIUS/2+MAX_RADIUS*0, radius_Hat,   radius_Hat);
  fill(  0, 255,   0);
   ellipse(MAX_RADIUS/2, MAX_RADIUS/2+MAX_RADIUS*1, radius_Kick,  radius_Kick);
  fill(  0,   0, 255);
  for(int i = 0; i < num_bands; i++)
    ellipse(MAX_RADIUS/2+MAX_RADIUS*i, MAX_RADIUS/2+MAX_RADIUS*2, radius_Onset[i], radius_Onset[i]);
  fill(255, 255,   0);
   ellipse(MAX_RADIUS/2, MAX_RADIUS/2+MAX_RADIUS*3, radius_Range, radius_Range);
  fill(  0, 255, 255);
   ellipse(MAX_RADIUS/2, MAX_RADIUS/2+MAX_RADIUS*4, radius_Snare, radius_Snare);

  // Text labels
  fill(255);
  text("  Hi-Hat  ", 0, 12+MAX_RADIUS*0);
  text("Kick Drum ", 0, 12+MAX_RADIUS*1);
  for(int i = 0; i < num_bands; i++)
    text(" Onset ("+i+")", i*MAX_RADIUS, 12+MAX_RADIUS*2);
  text(" Range (0, "+num_bands+", "+range_value+")", 0, 12+MAX_RADIUS*3);
  text("Snare Drum", 0, 12+MAX_RADIUS*4);

  text("Sensitivity: "+sensitivity, 300, 24);
}

void mouseMoved()
{
  range_value = (int)map( mouseY, 0, height, 1, num_bands);
  sensitivity = (int)map( mouseX, 0, width, 1, 1000 );
  beat.setSensitivity(sensitivity);
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