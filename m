From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] Add esrt support.
Date: Thu, 11 Dec 2014 15:21:20 -0500
Message-ID: <20141211202119.GG17171@fenchurch.internal.datastacks.com>
References: <1418257161.2856.4.camel@ranerica-desk01>
 <1418329096-8675-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418329096-8675-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 11, 2014 at 03:18:16PM -0500, Peter Jones wrote:
> Add sysfs files for EFI System Resource Table under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> v2 with suggestions from bpetkov.
> v3 with me remembering checkpatch.
> v4 without me typing struct decls completely wrong somehow.

Except it isn't.  Apparently I'm really having a rough week with
invoking git correctly.

-- 
        Peter
