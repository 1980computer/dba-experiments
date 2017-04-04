final int pNum = 50;
PVector[] ppos = new PVector[pNum];
float[] pm = new float[pNum];
PVector[] pa = new PVector[pNum];
boolean[] alive = new boolean[pNum];
int victim=0;

boolean stop=false;

void setup()
{
 size(720,720);
 smooth(2);
 noStroke();
 for(int i=0;i<pNum;i++)//init particles
 {
  ppos[i] = new PVector(random(width/3,2*width/3),random(height/3,2*height/3));
  pm[i]=random(5,15);
  pa[i] = new PVector(0,0);
  //alive[i]=true;
 }
}

float getR2(PVector p1, PVector p2)
{
  return pow(sqrt(p1.x*p2.x+p1.y*p2.y), 2);
}

void mousePressed()
{
  if(mouseButton==LEFT)
  {
      ppos[victim] = new PVector(mouseX,mouseY);//place a particle on click
      pm[victim]=random(5,15);
      pa[victim] = new PVector(0,0);
      alive[victim]=true;
      victim++;
      if(victim==pNum)
        victim=0;
  }
  else
    stop=!stop;
}

void draw()
{
  fill(color(0,30));//fading effect
  rect(0,0,width,height);

  for(int i=0;i<pNum;i++)
  {
    if(alive[i])
    {
      if(!stop)
      {
      for(int ii=0;ii<pNum;ii++)
      {
        if(i!=ii && alive[ii])
        {
          PVector tmp=new PVector();
          tmp.add(ppos[ii]).sub(ppos[i]);
          pa[i].add(tmp.normalize().mult((100.0*pm[i]*pm[ii]/getR2(ppos[i],ppos[ii])))); //F = G * m1*m2 / r^2
        }
      }
      ppos[i].add(pa[i]);
      if( (ppos[i].x>width-1) || (ppos[i].y>height-1) || (ppos[i].x<0) || (ppos[i].y<0) )//die out of window
        alive[i]=false;
      }
      fill(255);
      ellipse(ppos[i].x,ppos[i].y,pm[i],pm[i]);
    }
  }
}