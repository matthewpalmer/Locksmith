import Foundation

public enum LocksmithInternetProtocol: RawRepresentable {
    case FTP, FTPAccount, HTTP, IRC, NNTP, POP3, SMTP, SOCKS, IMAP, LDAP, AppleTalk, AFP, Telnet, SSH, FTPS, HTTPS, HTTPProxy, HTTPSProxy, FTPProxy, SMB, RTSP, RTSPProxy, DAAP, EPPC, IPP, NNTPS, LDAPS, TelnetS, IMAPS, IRCS, POP3S
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolFTP):
            self = LocksmithInternetProtocol.FTP
        case String(kSecAttrProtocolFTPAccount):
            self = LocksmithInternetProtocol.FTPAccount
        case String(kSecAttrProtocolHTTP):
            self = LocksmithInternetProtocol.HTTP
        case String(kSecAttrProtocolIRC):
            self = LocksmithInternetProtocol.IRC
        case String(kSecAttrProtocolNNTP):
            self = LocksmithInternetProtocol.NNTP
        case String(kSecAttrProtocolPOP3):
            self = LocksmithInternetProtocol.POP3
        case String(kSecAttrProtocolSMTP):
            self = LocksmithInternetProtocol.SMTP
        case String(kSecAttrProtocolSOCKS):
            self = LocksmithInternetProtocol.SOCKS
        case String(kSecAttrProtocolIMAP):
            self = LocksmithInternetProtocol.IMAP
        case String(kSecAttrProtocolLDAP):
            self = LocksmithInternetProtocol.LDAP
        case String(kSecAttrProtocolAppleTalk):
            self = LocksmithInternetProtocol.AppleTalk
        case String(kSecAttrProtocolAFP):
            self = LocksmithInternetProtocol.AFP
        case String(kSecAttrProtocolTelnet):
            self = LocksmithInternetProtocol.Telnet
        case String(kSecAttrProtocolSSH):
            self = LocksmithInternetProtocol.SSH
        case String(kSecAttrProtocolFTPS):
            self = LocksmithInternetProtocol.FTPS
        case String(kSecAttrProtocolHTTPS):
            self = LocksmithInternetProtocol.HTTPS
        case String(kSecAttrProtocolHTTPProxy):
            self = LocksmithInternetProtocol.HTTPProxy
        case String(kSecAttrProtocolHTTPSProxy):
            self = LocksmithInternetProtocol.HTTPSProxy
        case String(kSecAttrProtocolFTPProxy):
            self = LocksmithInternetProtocol.FTPProxy
        case String(kSecAttrProtocolSMB):
            self = LocksmithInternetProtocol.SMB
        case String(kSecAttrProtocolRTSP):
            self = LocksmithInternetProtocol.RTSP
        case String(kSecAttrProtocolRTSPProxy):
            self = LocksmithInternetProtocol.RTSPProxy
        case String(kSecAttrProtocolDAAP):
            self = LocksmithInternetProtocol.DAAP
        case String(kSecAttrProtocolEPPC):
            self = LocksmithInternetProtocol.EPPC
        case String(kSecAttrProtocolIPP):
            self = LocksmithInternetProtocol.IPP
        case String(kSecAttrProtocolNNTPS):
            self = LocksmithInternetProtocol.NNTPS
        case String(kSecAttrProtocolLDAPS):
            self = LocksmithInternetProtocol.LDAPS
        case String(kSecAttrProtocolTelnetS):
            self = LocksmithInternetProtocol.TelnetS
        case String(kSecAttrProtocolIMAPS):
            self = LocksmithInternetProtocol.IMAPS
        case String(kSecAttrProtocolIRCS):
            self = LocksmithInternetProtocol.IRCS
        case String(kSecAttrProtocolPOP3S):
            self = LocksmithInternetProtocol.POP3S
        default:
            self = LocksmithInternetProtocol.HTTP
        }
    }
    
    public var rawValue: String {
        switch self {
        case .FTP:
            return String(kSecAttrProtocolFTP)
        case .FTPAccount:
            return String(kSecAttrProtocolFTPAccount)
        case .HTTP:
            return String(kSecAttrProtocolHTTP)
        case .IRC:
            return String(kSecAttrProtocolIRC)
        case .NNTP:
            return String(kSecAttrProtocolNNTP)
        case .POP3:
            return String(kSecAttrProtocolPOP3)
        case .SMTP:
            return String(kSecAttrProtocolSMTP)
        case .SOCKS:
            return String(kSecAttrProtocolSOCKS)
        case .IMAP:
            return String(kSecAttrProtocolIMAP)
        case .LDAP:
            return String(kSecAttrProtocolLDAP)
        case .AppleTalk:
            return String(kSecAttrProtocolAppleTalk)
        case .AFP:
            return String(kSecAttrProtocolAFP)
        case .Telnet:
            return String(kSecAttrProtocolTelnet)
        case .SSH:
            return String(kSecAttrProtocolSSH)
        case .FTPS:
            return String(kSecAttrProtocolFTPS)
        case .HTTPS:
            return String(kSecAttrProtocolHTTPS)
        case .HTTPProxy:
            return String(kSecAttrProtocolHTTPProxy)
        case .HTTPSProxy:
            return String(kSecAttrProtocolHTTPSProxy)
        case .FTPProxy:
            return String(kSecAttrProtocolFTPProxy)
        case .SMB:
            return String(kSecAttrProtocolSMB)
        case .RTSP:
            return String(kSecAttrProtocolRTSP)
        case .RTSPProxy:
            return String(kSecAttrProtocolRTSPProxy)
        case .DAAP:
            return String(kSecAttrProtocolDAAP)
        case .EPPC:
            return String(kSecAttrProtocolEPPC)
        case .IPP:
            return String(kSecAttrProtocolIPP)
        case .NNTPS:
            return String(kSecAttrProtocolNNTPS)
        case .LDAPS:
            return String(kSecAttrProtocolLDAPS)
        case .TelnetS:
            return String(kSecAttrProtocolTelnetS)
        case .IMAPS:
            return String(kSecAttrProtocolIMAPS)
        case .IRCS:
            return String(kSecAttrProtocolIRCS)
        case .POP3S:
            return String(kSecAttrProtocolPOP3S)
        }
    }
}
