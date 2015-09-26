import Foundation

public enum LocksmithInternetProtocol: RawRepresentable {
    case FTP, FTPAccount, HTTP, IRC, NNTP, POP3, SMTP, SOCKS, IMAP, LDAP, AppleTalk, AFP, Telnet, SSH, FTPS, HTTPS, HTTPProxy, HTTPSProxy, FTPProxy, SMB, RTSP, RTSPProxy, DAAP, EPPC, IPP, NNTPS, LDAPS, TelnetS, IMAPS, IRCS, POP3S
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolFTP):
            self = FTP
        case String(kSecAttrProtocolFTPAccount):
            self = FTPAccount
        case String(kSecAttrProtocolHTTP):
            self = HTTP
        case String(kSecAttrProtocolIRC):
            self = IRC
        case String(kSecAttrProtocolNNTP):
            self = NNTP
        case String(kSecAttrProtocolPOP3):
            self = POP3
        case String(kSecAttrProtocolSMTP):
            self = SMTP
        case String(kSecAttrProtocolSOCKS):
            self = SOCKS
        case String(kSecAttrProtocolIMAP):
            self = IMAP
        case String(kSecAttrProtocolLDAP):
            self = LDAP
        case String(kSecAttrProtocolAppleTalk):
            self = AppleTalk
        case String(kSecAttrProtocolAFP):
            self = AFP
        case String(kSecAttrProtocolTelnet):
            self = Telnet
        case String(kSecAttrProtocolSSH):
            self = SSH
        case String(kSecAttrProtocolFTPS):
            self = FTPS
        case String(kSecAttrProtocolHTTPS):
            self = HTTPS
        case String(kSecAttrProtocolHTTPProxy):
            self = HTTPProxy
        case String(kSecAttrProtocolHTTPSProxy):
            self = HTTPSProxy
        case String(kSecAttrProtocolFTPProxy):
            self = FTPProxy
        case String(kSecAttrProtocolSMB):
            self = SMB
        case String(kSecAttrProtocolRTSP):
            self = RTSP
        case String(kSecAttrProtocolRTSPProxy):
            self = RTSPProxy
        case String(kSecAttrProtocolDAAP):
            self = DAAP
        case String(kSecAttrProtocolEPPC):
            self = EPPC
        case String(kSecAttrProtocolIPP):
            self = IPP
        case String(kSecAttrProtocolNNTPS):
            self = NNTPS
        case String(kSecAttrProtocolLDAPS):
            self = LDAPS
        case String(kSecAttrProtocolTelnetS):
            self = TelnetS
        case String(kSecAttrProtocolIMAPS):
            self = IMAPS
        case String(kSecAttrProtocolIRCS):
            self = IRCS
        case String(kSecAttrProtocolPOP3S):
            self = POP3S
        default:
            self = HTTP
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
