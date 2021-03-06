import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import SortFilterProxyModel 0.2

import 'components' as Components

FocusScope {
    id: root  

  //
  //
  //Variables, functions
  //
  //  
  
  Component.onCompleted: homeSound.play()
  
  //System index
  property var currentCollectionIndex : 0
  property var currentCollection: allCollections[currentCollectionIndex]
  
  //Games index
  property var currentGameIndex: 0
  property var currentGame: {
      if (currentCollection.shortName === "all-favorites")
          return api.allGames.get(allFavorites.mapToSource(currentGameIndex))
      if (currentCollection.shortName === "all-lastplayed")
          return api.allGames.get(allLastPlayed.mapToSource(currentGameIndex))
      if (searchValue !== '')
          return  currentCollection.games.get(searchGames.mapToSource(currentGameIndex))   
      return currentCollection.games.get(currentGameIndex)
  }
  
  property var allCollections: {
      let collections = api.collections.toVarArray()
      collections.unshift({"name": "All Games", "shortName": "all-allgames", "games": api.allGames})      
      collections.unshift({"name": "Last Played", "shortName": "all-lastplayed", "games": filterLastPlayed})
      collections.unshift({"name": "Favorites", "shortName": "all-favorites", "games": allFavorites})
      return collections
  }  
  
  FontLoader { id: titleFont; source: "assets/fonts/Nintendo_Switch_UI_Font.ttf" }
  
  property var currentPage : 'HomePage';
  
  property var themeLight : {
      "background": "#ebebeb",
      "accent": "#10adc5",
      "buttons": "white",
      "text":"#666666",
      "footer_icon":"rp2.png",
      "system_icon":"allsoft_icon.svg",
      "title":"#444"
  } 
  
  property var themeDark : {
    "background": "#222222",
    "accent": "#10adc5",
    "buttons": "#4a4a4a",
    "text":"#6f6f6f",
    "footer_icon":"rp2_dark.png",
    "system_icon":"allsoft_icon_dark.svg",    
    "title":"white"    
  }     
    
  property var theme : api.memory.get('theme') === 'themeLight' ? themeLight : themeDark ;
  
  property var searchValue: '';
  
  //used by Zoom in game lists
  property var itemsRow : api.memory.get('itemsRow') ? api.memory.get('itemsRow') : 3 ;
  
  //Used to hide or show the header
  property var headerHeightCorrection: api.memory.get('headerHeightCorrection') === 90 ? 90 : 0;
  property var rp2ratio : root.height === 480 ? 1.98 : 1.88
  property var wrapperCSS : {
      "width": 640,
      "height": vpx(480*rp2ratio),
      "background": theme.background,      
  }
  
  
  property var headerCSS : {
      "width": wrapperCSS.width,
      "height": 0,
      "background": Qt.rgba(0, 0, 0, .8),
  }
  
  
  property var footerCSS : {
      "width": wrapperCSS.width,
      "height": vpx(50*rp2ratio),
      "background": Qt.rgba(0, 0, 0, .8),
      
  }    
  
  property var mainCSS : {
      "width": wrapperCSS.width,
      "height": wrapperCSS.height - headerCSS.height - footerCSS.height,
      "background": Qt.rgba(0, 0, 0, .8),
      
  }   
  
  property var systemGradients : {
    "all-allgames":"#f5ad02",
    "all-lastplayed":"#3c4380",
    "all-favorites":"#d74c6f",
    "atari2600": "#8b511d",
    "doom": "#d52307",
    "dosbox": "#c1bd9b",
    "dreamcast": "#e78b1b",
    "fba": "#a52233",
    "fbn": "#a52233",
    "gb": "#acc641",
    "gamegear": "#b06502",
    "gba": "#fdd30d",
    "gbc": "#2d8d33",
    "genesis": "#175498",
    "mame": "#2f3f93",
    "mastersystem": "#23294c",
    "n64": "#ed2438",
    "nds": "#f3fcc0",
    "neogeo": "#6b1d1c",
    "neogeocd": "white",
    "neogeopocket": "white",
    "nes": "#d91c00",
    "pcengine": "#6b1d1c",
    "playstation": "white",
    "pokemini": "#f8d326",
    "psp": "#87e4dd",
    "scummvm": "white",
    "sega32x": "#52607b",
    "segacd": "#466efd",
    "snes": "#f60116",
    "wonderswan": "white"
  }   
    
  function showTitles(){
    if ( currentCollection.shortName.includes('all-')){
      return true
    }
    return false
  }  
    
  function randomColor(){
    return '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)
  }
  
  function toggleDarkMode(){
    if(theme === themeLight){
      api.memory.set('theme', 'themeDark');
    }else{
      api.memory.set('theme', 'themeLight');
    }
  }
  
 
  function toggleZoom(){
    if(headerHeightCorrection === 90){
      api.memory.set('headerHeightCorrection', 0);
      headerHeightCorrection = 0
      toggleSound.play()
    }else{
      api.memory.set('headerHeightCorrection', 90);
      headerHeightCorrection = 90
      toggleSound.play()
    }
  }
  
 
  function toggleItemsRow(){
    
      if ( api.memory.get('itemsRow') >= 5 ){
        api.memory.set('itemsRow', 3);
      }else{
        api.memory.set('itemsRow', itemsRow+1);
      }

  }  
  
  function navigate(page){
    currentPage = page
    
    goBackSound.play()
    /*pageNames    
    'HomePage'
    'ListPage'
    */
  }
  

  
  //Sounds
  SoundEffect {
    id: homeSound
    source: "assets/sound/Home.wav"
    volume: 1.0
  }   
  
  SoundEffect {
    id: navSound
    source: "assets/sound/Interface Click 1.wav"
    volume: 1.0
  }   
  
  
  SoundEffect {
    id: toggleSound
    source: "assets/sound/Interface Click 1.wav"
    volume: 1.0
  }   
    
  SoundEffect {
    id: goBackSound
    source: "assets/sound/EnterBack.wav"
    volume: 1.0
  }   
  SoundEffect {
    id: launchSound
    source: "assets/sound/PopupRunTitle.wav"
    volume: 1.0
  }       
  SoundEffect {
    id: settingsSound
    source: "assets/sound/Settings.wav"
    volume: 1.0
  }     

  SoundEffect {
    id: favSound
    source: "assets/sound/Border.wav"
    volume: 0.1
  }     
    
    property int maximumPlayedGames: {
        if (allLastPlayed.count >= 17) {
            return 17
        }
        return allLastPlayed.count
    }

    SortFilterProxyModel {
        id: allFavorites
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: allLastPlayed
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "lastPlayed"; value: ""; inverted: true; }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
        id: filterLastPlayed
        sourceModel: allLastPlayed
        filters: IndexFilter { maximumIndex: maximumPlayedGames }
    }

    SortFilterProxyModel {
        id: currentFavorites
        sourceModel: currentCollection.games
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }
                            
    
    SortFilterProxyModel {
    id: searchGames

        sourceModel: currentCollection.games
        filters: [            
            RegExpFilter { roleName: "title"; pattern: searchValue; caseSensitivity: Qt.CaseInsensitive; enabled: searchValue != "" }            
        ]
        // sorters: [
        //     RoleSorter { roleName: sortByFilter[sortByIndex]; sortOrder: orderBy }
        // ]
    }    
  
  
  //
  //
  //Actual UI
  //
  //
  


  //RP2 screen Boundaries, use it to trace a design
  Rectangle {
      id: wrapper
      color: wrapperCSS.background
      width: wrapperCSS.width
      height: wrapperCSS.height
      anchors.top: parent.top
        // Image {
        //     id: collectionLogo
        //     height: wrapperCSS.height        
        //     fillMode: Image.PreserveAspectFit
        //     source: "assets/bg.jpg"
        //     asynchronous: true        
        //     anchors.top: parent.top
        //     
        // }      
        
        // Rectangle{
        //     id: cropzone
        //     width: wrapperCSS.width
        //     height: wrapperCSS.height
        //     color: "transparent"
        //     border.color: "red"
        //     border.width: 1          
        // }
      

    
    
    Components.HomePage {
      visible: true ;
    }
    
    Components.ListPage {
      visible: currentPage === 'ListPage' ? 1 : 0 ;
    }  
  
  }   
  




}