From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: Drop link count of the right inode
Date: Mon, 07 Jan 2013 16:15:30 +0000
Message-ID: <1357575330.8203.65.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357333116.8203.50.camel@mfleming-mobl1.ger.corp.intel.com>
	 <44edfa54b80aedb674bdb482eef4f559030d9bf7.1357365172.git.lxiang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44edfa54b80aedb674bdb482eef4f559030d9bf7.1357365172.git.lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi<jlee"@suse.com, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2013-01-05 at 13:59 +0800, Lingzhu Xiang wrote:
> efivarfs_unlink() should drop the file's link count, not the directory's.
> 
> Signed-off-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Thanks, I've queued this up with Joey's Tested-by.

-- 
Matt Fleming, Intel Open Source Technology Center
