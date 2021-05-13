#ifndef _XT_NDMMARK_H
#define _XT_NDMMARK_H

#include <linux/types.h>

/* Must be in-sync with ndm/Netfilter/Typedefs.h */

enum xt_ndmmark_list {
	XT_NDMMARK_EMPTY            = 0x00,
	XT_NDMMARK_IPSEC_INPUT      = 0x01,
	XT_NDMMARK_IPSEC_OUTPUT     = 0x02,
	XT_NDMMARK_IPSEC_MASK       = 0x03,
	XT_NDMMARK_DISCOVERY_DROP   = 0x03,
	XT_NDMMARK_DNAT             = 0x80, // with mask
	XT_NDMMARK_PPTP_VPN         = 0x40, // with mask
	XT_NDMMARK_SSTP_VPN         = 0x20, // with mask
	XT_NDMMARK_L2TP_IPSEC_VPN   = 0x10, // with mask
	XT_NDMMARK_CHILLI           = 0x08, // with mask
	XT_NDMMARK_FWD              = 0x04, // with mask
	XT_NDMMARK_ALL              = 0xff  // all-wide mask
};

enum xt_ndmmark_kernel_list {
	XT_NDMMARK_KERNEL_NTC       = 0x01
};

struct xt_ndmmark_tginfo {
	__u8 mark, mask;
};

struct xt_ndmmark_mtinfo {
	__u8 mark, mask;
	__u8 invert;
};

#ifdef CONFIG_NETFILTER_XT_NDMMARK
static inline bool xt_ndmmark_is_fwd(struct sk_buff *skb)
{
	return (skb->ndm_mark & XT_NDMMARK_FWD) == XT_NDMMARK_FWD;
}
#else
static inline bool xt_ndmmark_is_fwd(struct sk_buff *skb)
{
	return false;
}
#endif

#endif /* _XT_NDMMARK_H */
