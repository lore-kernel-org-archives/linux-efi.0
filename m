From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Cannot add new efi boot entry
Date: Wed, 17 Apr 2013 16:29:10 +0200
Message-ID: <516EB1B6.7050506@suse.cz>
References: <516B1ED3.9040900@suse.cz> <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516D23B5.4070209-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/16/2013 12:11 PM, Matt Fleming wrote:
> On 16/04/13 10:56, joeyli wrote:
>> I think I just got the same situation on my side with Acer machine. I am
>> trying Matthew's new patchset hope can avoid this situation:
>>
>> https://lkml.org/lkml/2013/4/15/473
> 
> Please do let us know whether the patches work for you.

Hmm, where did efi_query_variable_store in 3/3 come from?

-- 
js
suse labs
