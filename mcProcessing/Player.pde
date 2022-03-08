class Player
{
    /*
    This object is here to gather all the information about the player.
    */
    public PVector pos;
    public PVector pastPos;
    public PVector speed;
    public PVector chunck;
    public PVector look = new PVector();
    public PVector sizeHitbox = new PVector(0.6, 1.6, 0.6);
    public boolean spectator = false;
    public float angleCamXZ;
    public float angleCamY;
    public PVector direction;
}
