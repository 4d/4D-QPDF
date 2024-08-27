## __About the 4D-QPDF Component__

The __4D-QPDF__ component provides the __PDF Get attachments__ method accessible within the 4D language.

This component utilizes an external open source library named __QPDF__ (https://qpdf.sourceforge.io) and is available on the 4D GitHub (https://github.com/4d).

The binaries are located in the /Resources/qpdf folder of the component. They are organized by architecture: /win/bin for Windows, /mac/intel/ for Mac Intel, and /mac/arm/ for Mac ARM. 
You will also find a config.json configuration file <sup>(1)</sup> in the same folder for custom installations.


To install and update __QPDF__ in your development environment, the component project must be executed as a standard project. 
Methods detailed below are accessible via the manual execution of methods.

![Exposed methods](https://github.com/4d/4D-QPDF/blob/main/pictures/QPDF-EXEC-METHODS.png)


---

The component installs __Homebrew__ (https://brew.sh/) <sup>(2)</sup> in your development environment, allowing you to update the external __QPDF__ libraries contained in the component's /Resources folder.



--- 

### QPDF Check Environment

This method allows you to determine if the QPDF library is accessible to the component for the current execution architecture and indicates its version.

Possible answers:

- **"COMPONENT" QPDF Ready! QPDF version: XX.X**  
  _Internal component QPDF is used_.

- **"SYSTEM" QPDF Ready! QPDF version: XX.X**  
  _External system QPDF is used_.

- **Config file not found run "QPDF UPDATE" method!**

- **QPDF is not installed on your system: RUN "QPDF UPDATE" method or "QPDF Use component" method!**

- **QPDF is not installed in your component: RUN "QPDF UPDATE" method or "QPDF Use system" method!**



--- 

### QPDF Update

This method installs or updates the __QPDF__ libraries for your architecture and for Windows. 
It should be executed on a Mac Intel and then on a Mac Silicon to update all architectures.

__Note__: The update system is not available if you are running 4D in Rosettta environment.


--- 

### QPDF Use component and QPDF Use system

These two methods indicate in a specific usage context to the local configuration file whether the component should use the __QPDF__ version from the component or the version used by the system.

The path to the config file is as follows:

__Folder__(_fk user preferences folder_).___folder___("4D-QPDF")

Example:
/Users/4D-dev/Library/Application Support/4D/4D-QPDF/configs/qpdf.json

---

<sup>(1)</sup> 
You can set your default configuration file. 
It is located here : /Resources/qpdf/config.json

  ___use_system___: is a boolean that indicates to the component whether you want to use the __QPDF__ binary installed on your system.

  ___custom_path___: optional, indicates a path where the binary installed on your system is located.


<sup>(2)</sup>
On the first installation of __Homebrew__, 4D may need to be run in sudo mode and may ask you to log in with an admin account.

## __How to build 4D-QPDF Component__

In order to notarize the component with Apple's services, its structure must adhere to certain rules. 
The QPDF binary files cannot be located in the Resources folder of the base. 
They should be placed in the Helpers folder at the same level as the Resources folder.

The internal buildApp of 4D does not currently copy this folder during the compilation of a component.

Therefore, we have included the "build 4D-QPDF" base, which uses the [Build4D](https://github.com/4d-depot/Build4D) component to include the Helpers folder during the component's build and signing process.

To build your own "4D-QPDF" component, use the "build 4D-QPDF" project.

Adapt the "build" method to your needs.  [settings documentation](https://github.com/4d-depot/Build4D/blob/main/Build4D/Documentation/Classes/Component.md)
, [visit HDI here](https://blog.4d.com/build-your-compiled-structure-or-component-with-build4d/)

[build method code](https://github.com/4d/4D-QPDF/blob/main/build%204D-QPDF/Project/Sources/Methods/build.4dm)

Execute the "build" method.

If the build is successful, a finder window opens with your built component.
