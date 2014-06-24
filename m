From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v6 1/9] efi: Use early_mem*() instead of early_io*()
Date: Tue, 24 Jun 2014 17:56:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32846B97@ORSMSX114.amr.corp.intel.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-2-git-send-email-daniel.kiper@oracle.com>
 <53A7F104020000780001C4BE@mail.emea.novell.com>
 <20140623135446.GG28489@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623135446.GG28489-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: "andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org" <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "jeremy-TSDbQ3PG+2Y@public.gmane.org" <jeremy-TSDbQ3PG+2Y@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org" <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, "boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org" <eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org" <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Yu, Fenghua" <fenghua.yu@intel>
List-Id: linux-efi@vger.kernel.org

> I am CC'ing IA-64 guys.

The *_unmap() functions are no-op on ia64 - because we have mappings for everything all the time
- the *_map() functions just need to compute the proper address to use to get the right attributes
(so we don't mix and match cacheable and uncachable access to the same address). But there is
nothing to tear down afterwards.

I do tend to agree with Daniel that is seems odd to setup the mapping with one class of function
and then tear it down with another.

-Tony
