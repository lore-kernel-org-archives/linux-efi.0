From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
Date: Wed, 30 Oct 2013 10:44:16 -0200
Message-ID: <CAGG-pUQZ2R0JMZuGi07cL5q4EABYouZJfMpkO6YPy+ry2WkbNw@mail.gmail.com>
References: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
	<20131030123850.GA8193@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131030123850.GA8193-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-br <kernel-br-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2013/10/30 Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>:
> On Mon, 14 Oct, at 03:37:17PM, Geyslan G. Bem wrote:
>> This reorganization:
>>
>> Adds 'attrsize' variable to make the code cleaner and more
>> understandable, replacing all 'sizeof(attributes)'.
>>
>> Removes 'bytes' prior assignment due this new approach.
>>
>> Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/efivarfs/file.c | 23 +++++++++--------------
>>  1 file changed, 9 insertions(+), 14 deletions(-)
>
> Hmm.. I'm not convinced this is much of an improvement. I think removing
> 'sizeof(attributes)' actually makes the code harder to read.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Do you want that I undo that? I aggre that the variable use only
reduces the line code.

-- 
Regards,

Geyslan G. Bem
hackingbits.com
