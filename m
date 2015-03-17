From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: efivarfs and writev() support
Date: Tue, 17 Mar 2015 09:03:38 -0700
Message-ID: <48E5761B-8142-4CDE-9AAD-BCD70C34BC13@holtmann.org>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org> <20150311134226.GB24174@codeblueprint.co.uk> <7F5112DD-6998-47D3-B6B9-5618E14E022A@holtmann.org> <20150312063437.GK29656@ZenIV.linux.org.uk> <BC49553F-B4CE-4ED5-A1CE-D180E200AA60@holtmann.org> <20150312170344.GN29656@ZenIV.linux.org.uk> <C20D75CF-FA82-43E5-BF70-E4E30E1D987B@holtmann.org> <20150317154630.GA25605@codeblueprint.co.uk>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150317154630.GA25605-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

>> I say we should support writev() on efivarfs. Not supporting it seems
>> odd especially since that is not documented anywhere. So yes, I am for
>> adding .write_iter() support and be done with that.
> 
> Well, as Al has explained it's not that writev() isn't supported, it's
> that having an iovec vector containing only the 4-byte variable
> attribute isn't currently supported.
> 
> Since writev() calls are intended to be atomic, and even though efivarfs
> gets fed the variable data in chunks we can process it in one go, I
> think allowing the scenario you describe is fine.

meaning only writev() with a single vector is supported.

>> Also please note that even write(,4) and write(,n) does not work
>> either. You can not write partial entries as it seems. Maybe you are
>> able to append, but it seems the initial creation of the variable has
>> to be done with a single write() call. Anything else ends up in a file
>> with 0 length.
> 
> Yes, that's by design. I guess it's to prohibit people from creating
> bogus EFI variables or accidentally deleting variables (a SetVariable()
> call with length 0 is a delete).

I have no problems with these semantics, but it means you need to add support for .write_iter since otherwise multiple vectors will not work. And really think that is better than forcing userspace to work around this limitation.

As I mentioned earlier, for me it was really obvious to use a vectored write for EFI variables. That just made sense to me. So seeing it not working caused confusion.

Regards

Marcel
