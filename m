From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: allow unloading when build as module
Date: Tue, 4 Nov 2014 16:56:26 +0000
Message-ID: <20141104165626.GA3592@console-pimps.org>
References: <1414099237-19081-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414099237-19081-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 23 Oct, at 11:20:37PM, Mathias Krause wrote:
> There is no need to keep the module loaded when it serves no function in
> case the EFI runtime services are disabled. Return an error in this case
> so loading the module will fail.
> 
> Also supply a module_exit function to allow unloading the module.
> 
> Last, but not least, set the owner of the file_system_type struct.
> 
> Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> ---
>  fs/efivarfs/super.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Thanks, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
