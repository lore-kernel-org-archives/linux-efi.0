From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC,PATCH] efivarfs: Don't delete efivar_entry structures on
 unlink
Date: Tue, 29 Jan 2013 07:45:29 +0900
Message-ID: <5106FF89.2020500@ozlabs.org>
References: <1359240720.964087.170020751085.1.gpush@pororo> <1359391539.8282.28.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391539.8282.28.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

> Isn't there a race here? Can't the efivar_entry be deleted and freed
> before we call efivar_get_entry()?
>
> The problem is you need to be able to ensure the validity of
> inode->i_private, but you can't in the open() function if you haven't
> already taken a reference to the variable. A ref count of some
> description needs to be incremented in efivarfs_fill_super() before the
> efivar_entry pointer is stored in the inode, and while we're holding the
> lock.

Yes, the intention is to bump the refcount any time we store the struct 
efivars_entry somewhere it might be referenced later (ie, in 
inode->i_private in this case). I'll add the ref when we create the 
inodes too.

One of my concerns with the current patch is using the empty list as an 
indicator whether the variable is present in firmware. Alternatively, we 
could do this with a new bool 'deleted' in the strut efivars_entry, 
which is set on unlink(). Any preferences?

Cheers,


Jeremy
