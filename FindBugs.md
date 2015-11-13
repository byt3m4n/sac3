Plugin de eclipse que permite encontrar errores en la app.

Installation

---


We provide update sites that allow you to automatically install FindBugs into Eclipse and also query and install updates. There are three different update sites

FindBugs Eclipse update sites

http://findbugs.cs.umd.edu/eclipse/

> Only provides official releases of FindBugs.
http://findbugs.cs.umd.edu/eclips-candidate/

> Provides official releases and release candidates of FindBugs.
http://findbugs.cs.umd.edu/eclipse-daily/

> Provides the daily build of FindBugs. No testing other than that it compiles.

You can also manually download the plugin from the following link: http://prdownloads.sourceforge.net/findbugs/edu.umd.cs.findbugs.plugin.eclipse_1.3.9.20090821.zip?download. Extract it in Eclipse's "plugins" subdirectory. (So 

<eclipse\_install\_dir>

/plugins/edu.umd.cs.findbugs.plugin.eclipse\_1.3.9.20090821/findbugs.png should be the path to the FindBugs logo.)

Once the plugin is extracted, start Eclipse and choose Help → About Eclipse Platform → Plug-in Details. You should find a plugin called "FindBugs Plug-in" provided by "FindBugs Project".


Using the Plugin

---


To get started, right click on a Java project in Package Explorer, and select the option labeled "Find Bugs". FindBugs will run, and problem markers (displayed in source windows, and also in the Eclipse Problems view) will point to locations in your code which have been identified as potential instances of bug patterns.

You can also run FindBugs on existing java archives (jar, ear, zip, war etc). Simply create an empty Java project and attach archives to the project classpath. Having that, you can now right click the archive node in Package Explorer and select the option labeled "Find Bugs". If you additionally configure the source code locations for the binaries, FindBugs will also link the generated warnings to the right source files.

You may customize how FindBugs runs by opening the Properties dialog for a Java project, and choosing the "Findbugs" property page. Options you may choose include:

> Enable or disable the "Run FindBugs Automatically" checkbox. When enabled, FindBugs will run every time you modify a Java class within the project.

> Choose minimum warning priority and enabled bug categories. These options will choose which warnings are shown. For example, if you select the "Medium" warning priority, only Medium and High priority warnings will be shown. Similarly, if you uncheck the "Style" checkbox, no warnings in the Style category will be displayed.

> Select detectors. The table allows you to select which detectors you want to enable for your project.