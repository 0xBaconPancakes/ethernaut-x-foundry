object "MagicNumberAttack" {
    code {
        // datacopy(0x0, dataoffset("runtime"), datasize("runtime"))
        // return(0x0, datasize("runtime"))
        datacopy(0x0, dataoffset("runtime"), datasize("runtime"))
        return(0x0, datasize("runtime"))
    }
    object "runtime" {
        code {
            mstore(0x0, 0x2a) // save to 0 address and save gas
            return(0x0, 0x20)
        }
    }
}