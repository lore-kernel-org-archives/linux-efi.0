From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH RESEND] efivarfs: Ensure VariableName is NUL-terminated
Date: Thu, 02 Apr 2015 11:28:52 -0700
Message-ID: <1427999332.7230.12.camel@srcf.ucam.org>
References: <1427960340-5339-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427960340-5339-1-git-send-email-ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-04-02 at 08:39 +0100, Ross Lagerwall wrote:
> Some buggy firmware implementations update VariableNameSize on success
> such that it does not include the final NUL character which results in
> garbage in the efivarfs name entries.  Use kzalloc on the efivar_entry
> (as is done in efivars.c) to ensure that the name is always
> NUL-terminated.
> 
> The buggy firmware is:
> BIOS Information
>         Vendor: Intel Corp.
>         Version: S1200RP.86B.02.02.0005.102320140911
>         Release Date: 10/23/2014
>         BIOS Revision: 4.6
> System Information
>         Manufacturer: Intel Corporation
>         Product Name: S1200RP_SE
> 
> Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
ACKed-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
