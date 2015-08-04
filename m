From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V3 request from stable 3.10 to 3.14] efi: fix 32bit
 kernel boot failed problem using efi
Date: Tue, 4 Aug 2015 18:12:56 +0100
Message-ID: <20150804171256.GA4332@codeblueprint.co.uk>
References: <1438653081-25746-1-git-send-email-fupan.li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438653081-25746-1-git-send-email-fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 04 Aug, at 09:51:21AM, fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> From: Fupan Li <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> 
> Commit 35d5134b7d5a
> ("x86/efi: Correct EFI boot stub use of code32_start")
> imported a bug, which will cause 32bit kernel boot failed
> using efi method. It should use the label's address instead
> of the value stored in the label to caculate the address of
> code32_start.
> 
> Signed-off-by: Fupan Li <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> ---
>  arch/x86/boot/compressed/head_32.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
