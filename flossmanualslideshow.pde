/**
 * Slide show.
 * 
 * Looks in the data directory of its project directory. 
 * Finds the .png and .jpg files.
 * Displays them in a loop on a black background.
 * 
 * You should create a data directory at the same level as the .pde file.
 * Put your images there.
 * 
 * @author: Alexandre Quessy <alexandre@quessy.net>
 * @date: 2010-09-08
 * @license: GPL v3 or above
 */

// The files must be in the data folder
// of the current sketch to load successfully

PImage image_a;
float interval = 1.0; // delay in seconds between each image
int WIDTH = 400;
int HEIGHT = 300;
import java.io.*;

String[] file_names;
int current_image_index = 0;
int time_last_shown = 0;

/**
 * Sets file_names array with image file names in the data directory.
 */
String[] get_images_list()
{
  java.io.File folder = new java.io.File(dataPath(""));
  // let's set a filter (which returns true if file's extension is .jpg or .png)
  java.io.FilenameFilter imgFilter = new java.io.FilenameFilter() 
  {
    public boolean accept(File dir, String name) 
    {
      return name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".png");
    }
  };
  // list the files in the data folder, passing the filter as parameter
  String[] file_names = folder.list(imgFilter);
  println(file_names);
  // get and display the number of jpg files
  // display the filenames
  if (file_names == null)
  {
    println("Did not find any image.");
    return new String[0];
  }
  else 
  {
    println("Found " + file_names.length + " image files in the data directory");
  
    for (int i = 0; i < file_names.length; i++) 
    {
      println(file_names[i]);
    }
    return file_names;
  }
}

void setup() 
{
  file_names = new String[0];
  size(WIDTH, HEIGHT);
  background(0);
  file_names = get_images_list();
  load_image_at_current_index();
  //a = loadImage("jelly.jpg");
  next_image();
  image(image_a, 0, 0);
}

void load_image_at_current_index()
{
  if (file_names.length != 0)
  {  
    image_a = loadImage(file_names[current_image_index]);
  }
  time_last_shown = millis();
}

boolean next_image()
{
  int previous_image_index = current_image_index;
  if (current_image_index >= (file_names.length - 1))
  {
    current_image_index = 0;
  } else {
    current_image_index++;
  }
  if (previous_image_index != current_image_index)
  {
    println("Should load " + current_image_index);
    return true;
  } else {
    println("No next image to load");
    return false;
  }
}

void draw() 
{
  if (millis() - time_last_shown > int(interval * 1000))
  {
    time_last_shown = millis();
    println("Time to display next image."); 
    if (next_image())
    {
      load_image_at_current_index();
      background(0);
      image(image_a, 0, 0);
    }
  }
}

