From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH RESEND] efivarfs: Ensure VariableName is NUL-terminated
Date: Mon, 6 Apr 2015 19:39:49 +0100
Message-ID: <20150406183949.GA7511@codeblueprint.co.uk>
References: <1427960340-5339-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427960340-5339-1-git-send-email-ross.lagerwall@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: linux-efi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 02 Apr, at 08:39:00AM, Ross Lagerwall wrote:
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
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> ---
>  fs/efivarfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied with Matthew's ACK!

-- 
Matt Fleming, Intel Open Source Technology Center
