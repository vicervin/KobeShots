

plot.court<-function(offset_y){
  
  plot(c(-300,300),c(-100,1000), type = "n" ,xlab ="", ylab ="")
  
  #Court
  rect(-250, 0 - offset_y  , 250 , 940 - offset_y)
  # Division line and middle circles
  lines(c(-250, 250) , c(470 - offset_y, 470 - offset_y) )
  lines(arc.polygon(0,470 - offset_y,20))
  lines(arc.polygon(0,470 - offset_y,60))

  plot.halfCourt<-function(mirror = FALSE){
      y0 <- 940 - offset_y
      mirr <-1
      invOffset <-1
      if (mirror) {
        y0 <- 0
        mirr<- -1
        invOffset <-0
      }
      y<-function(y.coordinate){
        return(940 - offset_y - y0 + mirr*(y.coordinate - invOffset*offset_y))
      }
      
      arc.polygon <- function (x , y , r , N = 100 , right= 0.0 , left= 2*pi) {
        n <- seq(right, left, length = N) 
        coords <- t(rbind( x + r*cos(n) , y + r*sin(n))) 
        return(coords) 
      }
      
      # Small circle
      lines(arc.polygon(0 , y(190),60))
      
      # Basket
      rect(-30 , y(40) , 30 , y(40) )
      lines(arc.polygon(0,y(55.5),15))
      
      # Inner box
      rect(-80, y(0) , 80 , y(190) )
      rect(-60, y(0) , 60 , y(190) )
      
      # 3 Point area
      lines(c(-220,-220), c(y(0), y(140)))
      lines(c( 220, 220), c(y(0), y(140)))
      
      right_theta = mirr*atan2( 84.5, 220)
      left_theta = mirr*atan2( 84.5 , -220)
      coordinates <-arc.polygon(0, y(55.5), 237.5, right = right_theta, left = left_theta)
      lines(coordinates)  
      
    }
  
  plot.halfCourt(FALSE) #Bottom
  plot.halfCourt(TRUE) #Top
}