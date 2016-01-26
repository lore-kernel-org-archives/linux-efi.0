From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: make checkpatch complain less about efi.h GUID
 additions.
Date: Tue, 26 Jan 2016 15:00:37 +0000
Message-ID: <20160126150037.GD7478@codeblueprint.co.uk>
References: <1453753878-2771-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453753878-2771-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Jan, at 03:31:18PM, Peter Jones wrote:
> This reformats the GUID definitions in include/linux/efi.h so that if
> you add another one with the same style, checkpatch won't complain about
> it.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/efi.h | 63 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 21 deletions(-)

  total: 64 errors, 122 warnings, 1295 lines checked

Haha, awesome.

Your patch looks good to me, and has the added benefit that the layout
more closely resembles how GUIDs are displayed in the UEFI spec.

Thanks Peter, applied.
