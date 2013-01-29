From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC,PATCH] efivarfs: Don't delete efivar_entry structures on
 unlink
Date: Tue, 29 Jan 2013 16:08:54 +0000
Message-ID: <1359475734.8282.93.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359240720.964087.170020751085.1.gpush@pororo>
	 <1359391539.8282.28.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5106FF89.2020500@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5106FF89.2020500-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-01-29 at 07:45 +0900, Jeremy Kerr wrote:
> Yes, the intention is to bump the refcount any time we store the struct 
> efivars_entry somewhere it might be referenced later (ie, in 
> inode->i_private in this case). I'll add the ref when we create the 
> inodes too.
> 
> One of my concerns with the current patch is using the empty list as an 
> indicator whether the variable is present in firmware. Alternatively, we 
> could do this with a new bool 'deleted' in the strut efivars_entry, 
> which is set on unlink(). Any preferences?

I think using presence on the efivar list to indicate that a variable
exists in the firmware is a nice and simple solution.

-- 
Matt Fleming, Intel Open Source Technology Center
