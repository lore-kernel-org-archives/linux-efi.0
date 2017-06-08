From: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi: fix boot panic because of invalid bgrt image
 address
Date: Thu, 8 Jun 2017 13:22:54 +0200
Message-ID: <287d40cd-d0e6-ed98-774a-766070b1806e@gmail.com>
References: <20170608053239.GA31232@dhcp-128-65.nay.redhat.com>
 <20170608053822.GB31232@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608053822.GB31232-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 08.06.2017 at 07:38 wrote Dave Young:
> Maniaxx, can you verify it on your machine? It passed my test with
> an emulation of your wrong address.

Works. Bails out properly on 4.12.0-rc4-gb29794ec95c6.

[    0.000000] efi_bgrt: Ignoring BGRT: invalid image address
