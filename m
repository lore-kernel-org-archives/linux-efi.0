From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efivarfs: make efivarfs_file_ioctl static.
Date: Tue, 3 May 2016 15:56:00 +0100
Message-ID: <20160503145600.GZ2839@codeblueprint.co.uk>
References: <1462213506-1860-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462213506-1860-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 02 May, at 02:25:06PM, Peter Jones wrote:
> There are no callers except through the file_operations struct below
> this, so it should be static like everything else here.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/efivarfs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Peter, applied.
