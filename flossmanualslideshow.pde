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

/**
 * Info about an image to show.
 */
class ImageInfo
{
  String name;
  float duration;
  ImageInfo(String initial_name, float initial_duration)
  {
    this.name = initial_name;
    this.duration = initial_duration;
  }
}

int current_image_index = 0;
int time_last_shown = 0;
PImage image_a;
float interval = 1.0; // delay in seconds between each image
int WIDTH = 400;
int HEIGHT = 300;
ArrayList images;

/**
 * Parses the config file and updates the config variables.
 * The config.xml file must be in the project's "data" directory
 * 
 * Here is how it should look:
 * <?xml version="1.0"?>
 * <config>
 *   <size width="400" height="300" />
 *   <images>
 *     <image duration="2.0">foo.jpg</image>
 *   </images>
 * </config>
 * 
 * Clears and populates he images global var.
 * Sets the WIDTH and HEIGHT global vars.
 */
void load_config()
{
  images.clear(); // clears the images global member

  XMLElement root;
  String FILE_NAME = "config.xml";
  root = new XMLElement(this, FILE_NAME);
  println("Loading " + FILE_NAME);
  int num_nodes = root.getChildCount();
  if (num_nodes != 2)
  {
    println("Error: there must be two XML children to " + root.getName() + " but there are " + num_nodes);
  } 
  else {
    for (int i = 0; i < num_nodes; i++)
    {
      XMLElement node = root.getChild(i);
      if (node.getName().equals("size"))
      {
        WIDTH = node.getIntAttribute("width");
        HEIGHT = node.getIntAttribute("width");
        println("Window size: width=" + WIDTH + " height=" + HEIGHT);
      } 
      else if (node.getName().equals("images"))
      {
        int number_of_images = node.getChildCount();
        println("There are " + number_of_images + " children to " + root.getName());
    
        for (int j = 0; j < number_of_images; j++) 
        {
          XMLElement img = node.getChild(j);
          ImageInfo info = new ImageInfo(img.getContent(), img.getFloatAttribute("duration"));
          images.add(info);
          println("Found image " + info.name + " (" + info.duration + " s)");
        }
      } else {
        println("Unknown node name: " + node.getName());
      }
    }
  }
}

void setup() 
{
  //file_names = new String[0];
  images = new ArrayList();
  load_config();
  size(WIDTH, HEIGHT);
  background(0);
  //file_names = get_images_list();
  load_image_at_current_index();
  //a = loadImage("jelly.jpg");
  if (images.size() != 0)
  {
    next_image();
    image(image_a, 0, 0);
  } else {
    println("No image to show.");
  }
}

/**
 * Updates the current pixel data with the image of the current index.
 */
void load_image_at_current_index()
{
  if (images.size() != 0)
  {
    ImageInfo info = (ImageInfo) images.get(current_image_index);
    try
    {
      image_a = loadImage(info.name);
    } catch(NullPointerException e) {
      println("Image not found? " + e);
    }
  }
  time_last_shown = millis();
}

/**
 * Checks if there is a next image to load. Update the index if so.
 */
boolean next_image()
{
  int previous_image_index = current_image_index;
  if (current_image_index >= (images.size() - 1))
  {
    current_image_index = 0;
  } 
  else {
    current_image_index++;
  }
  if (previous_image_index != current_image_index)
  {
    println("Should load " + current_image_index);
    return true;
  } 
  else {
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
      try 
      {
        image(image_a, 0, 0);
      } catch(NullPointerException e) {
        ImageInfo info = (ImageInfo) images.get(current_image_index);
        println("ERROR loading image " + info.name);
      }
    } else {
      //println("No image to show.");
    }
  }
}

void stop()
{
  println("Goodbye");
}
