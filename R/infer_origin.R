#' @title Infer origin
#' @description Find the minimum and maximum of occurrence. Here the minimum and maximum should match the resolution of the grid.
#' @author Xiao Feng
#'
#' @param input_occ Spatial points
#' @param fun Function used to infer the origin
#' @param flag_unit Character. Should be a string; default value is meter It also can "degree","minute","second".
#
#' @param filters A series of values used as dividend of the coordinates to find the origin
#'
infer_origin = function(input_occ,
                        fun=min,
                        flag_unit="meter",
                        filters = sort(c (10^(2:10), 10^(3:10)/2  ))
){
  if (flag_unit=="minute") {
    input_occ@coords = input_occ@coords * 60
  } else if(flag_unit=="second"){
    input_occ@coords = input_occ@coords * 3600
  }

  if(length(filters)== 2){
    filters_x=filters[1]
    filters_y=filters[2]
  } else{
    filters_x=filters
    filters_y=filters
  }

  M_y = fun(input_occ@coords[,2])
  M_y_group = unique( c ( round( M_y),
                          ceiling( M_y),
                          floor( M_y) ) )
  for (p in filters_y){
    temp_reminder = M_y_group %% p == 0
    if(  any( temp_reminder )   ){
      print(p)
      sel_M_y = M_y_group[ which(temp_reminder)]
      break
    }
    sel_M_y = min(M_y_group)
  }
  M_x = fun(input_occ@coords[,1])
  M_x_group = unique( c ( round( M_x),
                          ceiling( M_x),
                          floor( M_x) ) )
  for (p in filters_x){
    temp_reminder = M_x_group %% p == 0
    if(  any( temp_reminder )   ){
      print(p)
      sel_M_x = M_x_group[ which(temp_reminder)]
      break
    }
    sel_M_x = min(M_x_group)
  }

  out_put = c  (sel_M_x,sel_M_y)

  if (flag_unit=="minute") {
    out_put= out_put/ 60
  } else if(flag_unit=="second"){
    out_put = out_put/ 3600
  }

  return ( out_put)
}
