String image_selected = "59";

PImage img_02;
PImage seg_t_02;

PImage img_16;
PImage seg_t_16;

PImage img_18;
PImage seg_t_18;

PImage img_52;
PImage seg_t_52;

PImage img_59;
PImage seg_t_59;

void setup() {
  
  // unfortunately there is no way to define the size after the image load
  // comment out the size of the other images that are not going to be used
  
  // img 02
  //size((666*4), 500);
  
  // img 16
  //size((750*4), 500);
  
  // img 18
  //size((666*4), 500);
  
  // img 52
  //size((500*4), 582);
  
  // img 59
  size((509*4), 500);
  
  // Load the images
  img_02 = loadImage("image_0002.jpg");
  seg_t_02 = loadImage("image_0002_g.png");
  
  img_16 = loadImage("image_0016.jpg");
  seg_t_16 = loadImage("image_0016_g.png");
  
  img_18 = loadImage("image_0018.jpg");
  seg_t_18 = loadImage("image_0018_g.png");
  
  img_52 = loadImage("image_0052.jpg");
  seg_t_52 = loadImage("image_0052_g.png");
  
  img_59 = loadImage("image_0059.jpg");
  seg_t_59 = loadImage("image_0059_g.png");
  
  noLoop();
}

void draw() 
{
  PImage seg_02 = seg_flower_0002(img_02);
  PImage trace_02 = trace_back_image(img_02, seg_02);
  seg_02.save("image_0002_s.jpg");
  trace_02.save("image_0002_t.jpg");
 
  PImage seg_16 = seg_flower_0016(img_16);
  PImage trace_16 = trace_back_image(img_16, seg_16);
  seg_16.save("image_0016_s.jpg");
  trace_16.save("image_0016_t.jpg");
  
  PImage seg_18 = seg_flower_0018(img_18);
  PImage trace_18 = trace_back_image(img_18, seg_18);
  seg_18.save("image_0018_s.jpg");
  trace_18.save("image_0018_t.jpg");
  
  PImage seg_52 = seg_flower_0052(img_52);
  PImage trace_52 = trace_back_image(img_52, seg_52);
  seg_52.save("image_0052_s.jpg");
  trace_52.save("image_0052_t.jpg");
  
  PImage seg_59 = seg_flower_0059(img_59);
  PImage trace_59 = trace_back_image(img_59, seg_59);
  seg_59.save("image_0059_s.jpg");
  trace_59.save("image_0059_t.jpg");
  
  println("Statistics img 02:");
  get_statistics(seg_t_02, seg_02);
  println();
  
  println("Statistics img 16:");
  get_statistics(seg_t_16, seg_16);
  println();
  
  println("Statistics img 18:");
  get_statistics(seg_t_18, seg_18);
  println();
  
  println("Statistics img 52:");
  get_statistics(seg_t_52, seg_52);
  println();
  
  println("Statistics img 59:");
  get_statistics(seg_t_59, seg_59);
  println();
  
  // select the image to be show
  PImage img;
  PImage seg_t;
  PImage seg;
  PImage trace;
  
  if(image_selected == "02")
  {
    img = img_02;
    seg_t = seg_t_02;
    seg = seg_02;
    trace = trace_02;
  }
  
  else if (image_selected == "16")
  {
    img = img_16;
    seg_t = seg_t_16;
    seg = seg_16;
    trace = trace_16;
  }
  
  else if (image_selected == "18")
  {
    img = img_18;
    seg_t = seg_t_18;
    seg = seg_18;
    trace = trace_18;
  }
  
  else if (image_selected == "52")
  {
    img = img_52;
    seg_t = seg_t_52;
    seg = seg_52;
    trace = trace_52;
  }
  
  else if (image_selected == "59")
  {
    img = img_59;
    seg_t = seg_t_59;
    seg = seg_59;
    trace = trace_59;
  } 
  else
  {
    img = createImage(0, 0, 0);
    seg_t = createImage(0, 0, 0);
    seg = createImage(0, 0, 0);
    trace = createImage(0, 0, 0);
    println("No img selected");
  }
  
  image(img, 0, 0);
  image(seg_t, img.width, 0);
  image(seg, (img.width*2), 0);
  image(trace, (img.width*3), 0);
  
  save("image_00" + image_selected + "_work.jpg");
}

PImage trace_back_image(PImage source, PImage mask)
{
  PImage traced_img = createImage(source.width, source.height, RGB);
  
  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      int pos = y*source.width + x;
      
      if(red(mask.pixels[pos]) > 0)
        traced_img.pixels[pos] = source.pixels[pos];
      else
        traced_img.pixels[pos] = 0;
    }
  }
  return traced_img;
}

void get_statistics(PImage mask_ref, PImage mask_gen)
{
  int false_positive = 0;
  int false_negative = 0;
  int precision = 0;
  int ref_size_positives = 0;
  int ref_size_negatives = 0;
  for (int y = 0; y < mask_ref.height; y++) {
    for (int x = 0; x < mask_ref.width; x++) {
      int pos = y*mask_ref.width + x;
      
      if(red(mask_ref.pixels[pos]) == 0 && red(mask_gen.pixels[pos]) == 255)
        false_positive++;
      
      if(red(mask_ref.pixels[pos]) == 255 && red(mask_gen.pixels[pos]) == 0)
        false_negative++;
        
      if(red(mask_ref.pixels[pos]) == 255 && red(mask_gen.pixels[pos]) == 255)
        precision++;
        
      if(red(mask_ref.pixels[pos]) == 0)
        ref_size_positives++;
        
      if(red(mask_ref.pixels[pos]) == 255)
        ref_size_negatives++;
    }
  }
  int image_size = (mask_ref.height * mask_ref.width);
  
  float false_positive_per = ((float(false_positive)/ref_size_positives) * 100);
  float false_negative_per = ((float(false_negative)/ref_size_negatives) * 100);
  float precision_per = ((float(precision)/ref_size_negatives) * 100);
  
  println("False positives:" + false_positive);
  println("False positives (%):" + false_positive_per);
  println("False negative:" + false_negative);
  println("False negative (%):" + false_negative_per);
  println("Precision:" + precision);
  println("Precision (%):" + precision_per);
  println("Mask ref positives:" + ref_size_positives);
  println("Mask ref negatives:" + ref_size_negatives);
  println("Image size:" + (mask_ref.height * mask_ref.width));
}

PImage seg_flower_0018(PImage img)
{
  // 666x500
  //PImage img = loadImage("image_0018.jpg");
  
  // Create a mask to isolate yellow pixels
  PImage img_seg = createImage(img.width, img.height, RGB);
  img_seg.loadPixels();
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      
      float green = green(img.pixels[pos]);
      float red = red(img.pixels[pos]);
      
      float average = (red+green)/2;
      
      float brightAjust = average + 20;
      
      // if the pixel is above a threadhold set it to black else set it to white
      if(brightAjust > 255)
        brightAjust = 255;
      else if(brightAjust < 0)
        brightAjust = 0;
        
      // if the pixel is above a threadhold set it to white else set it to black
      if(brightAjust > 230)
        brightAjust = 255;
      else
        brightAjust = 0;
      
      img_seg.pixels[pos] = color(int(brightAjust));
    }
  }
   
  return img_seg;
}

//============================================================================

PImage seg_flower_0059(PImage img)
{
  // 509x500
  // PImage img = loadImage("image_0059.jpg");
  
  // Create a mask to isolate yellow pixels
  PImage img_seg = createImage(img.width, img.height, RGB);
  img_seg.loadPixels();
  
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      
      float blue = blue(img.pixels[pos]);
      float average = int(blue);
      
      float brightAjust = average - 25;
      
      // check if the limit for bright execceded
      if(brightAjust > 255)
        brightAjust = 255;
      else if(brightAjust < 0)
        brightAjust = 0;
      
      // if the pixel is above a threadhold set it to black else set it to white
      if(brightAjust > 20)
        brightAjust = 0;
      else
        brightAjust = 255;
      
      img_seg.pixels[pos] = color(brightAjust);
    }
  }
  img_seg.updatePixels();
  return img_seg;
}

//================================================================================================

PImage seg_flower_0002(PImage img)
{
  // 666x500
  // PImage img = loadImage("image_0002.jpg");
  
  // Create a mask to isolate yellow pixels
  PImage img_seg = createImage(img.width, img.height, RGB);
  img_seg.loadPixels();
  
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      
      float green = green(img.pixels[pos]);
      float red = red(img.pixels[pos]);
      float blue = blue(img.pixels[pos]);
      
      float average = (green+red)/2;
      
      float brightAjust = average - (blue-190);
      
      // check if the limit for bright execceded
      if(brightAjust > 255)
        brightAjust = 255;
      else if(brightAjust < 0)
        brightAjust = 0;
      
      // if the pixel is above a threadhold set it to black else set it to white
     if(brightAjust > 249)
       brightAjust = 255;
      else
        brightAjust = 0;
      img_seg.pixels[pos] = color(brightAjust);
    }
  }
  img_seg.updatePixels();
  return img_seg;
}

//================================================================================================================

PImage seg_flower_0016(PImage img)
{
  // 750x500
  // PImage img = loadImage("image_0016.jpg");
  
  // Create a mask to isolate yellow pixels
  PImage img_seg = createImage(img.width, img.height, RGB);
  img_seg.loadPixels();
  
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      
      float green = green(img.pixels[pos]);
      float red = red(img.pixels[pos]);
      float blue = blue(img.pixels[pos]);
      
      
      float average = (green+red)/2 - blue;
      
      float brightAjust = average + 30;
      
     // print(brightAjust);
      
      // check if the limit for bright execceded
      if(brightAjust > 255)
        brightAjust = 255;
      else if(brightAjust < 0)
        brightAjust = 0;
      
       //if the pixel is above a threadhold set it to black else set it to white
      if(brightAjust > 85)
       brightAjust = 255;
      else
       brightAjust = 0;
      
      img_seg.pixels[pos] = color(brightAjust);
    }
  }
  img_seg.updatePixels();
  return img_seg;
}

//===================================================================================


PImage seg_flower_0052(PImage img)
{
  // 750x500
  //PImage img = loadImage("image_0052.jpg");
  
  // Create a mask to isolate yellow pixels
  PImage img_seg = createImage(img.width, img.height, RGB);
  img_seg.loadPixels();
  
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      
      float green = green(img.pixels[pos]);
      float red = red(img.pixels[pos]);
      float blue = blue(img.pixels[pos]);
      
      float average = ((green+100)+(red+100))/2;
      
      float brightAjust = average -100;
      
     // print(brightAjust);
      
      // check if the limit for bright execceded
      if(brightAjust > 255)
        brightAjust = 255;
      else if(brightAjust < 0)
        brightAjust = 0;
      
       //if the pixel is above a threadhold set it to black else set it to white
      if(brightAjust > 211)
       brightAjust = 255;
      else
       brightAjust = 0;
      
      img_seg.pixels[pos] = color(brightAjust);
    }
  }
  img_seg.updatePixels();
  return img_seg;
}
