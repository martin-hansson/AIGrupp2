//Grupp 02:
// Alexandra Jansson, alja5888
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

class Team2 extends Team {

  Team2(int team_id, int tank_size, color c, 
    PVector tank0_startpos, int tank0_id, /* CannonBall ball0,  */
    PVector tank1_startpos, int tank1_id, /* CannonBall ball1,  */
    PVector tank2_startpos, int tank2_id/* , CannonBall ball2 */) {
    super(team_id, tank_size, c, tank0_startpos, tank0_id, /* ball0, */ tank1_startpos, tank1_id, /* ball1,  */tank2_startpos, tank2_id/* , ball2 */);  

    tanks[0] = new Tank(tank0_id, this, this.tank0_startpos, this.tank_size/* , ball0 */);
    tanks[1] = new Tank(tank1_id, this, this.tank1_startpos, this.tank_size/* , ball1 */);
    tanks[2] = new Tank(tank2_id, this, this.tank2_startpos, this.tank_size/* , ball2 */);

    //this.homebase_x = width - 151;
    //this.homebase_y = height - 351;
  }
  
}
