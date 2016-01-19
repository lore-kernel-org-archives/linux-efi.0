From: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Tue, 19 Jan 2016 23:47:37 +0530
Message-ID: <20160119181737.GB15850@linux.vnet.ibm.com>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
 <20160115162011.GA2935@linux.vnet.ibm.com>
 <20160115222921.GA5378@codeblueprint.co.uk>
 <20160117173248.GA28841@linux.vnet.ibm.com>
 <20160118154001.GA2607@codeblueprint.co.uk>
 <20160119104715.GA15850@linux.vnet.ibm.com>
 <20160119154241.GA3615@codeblueprint.co.uk>
Reply-To: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160119154241.GA3615-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> 
> OK could you add efi=debug to your kernel cmdline and try this patch
> instead of the one that returns early from
> efi_sync_low_kernel_mappings()?
> 
> I also pushed out all the changes to the following branch if that's
> easier to pull and build,
> 
>   https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=bug/efi/srikar

Thanks,  This kernel again goes back to the previous state i.e I cant
boot with this changes applied.

-- 
Thanks and Regards
Srikar Dronamraju
