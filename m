From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Cannot add new efi boot entry
Date: Mon, 22 Apr 2013 13:20:53 +0100
Message-ID: <51752B25.9020809@console-pimps.org>
References: <516B1ED3.9040900@suse.cz>  <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>  <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>  <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>  <517519E3.2030409@console-pimps.org> <1366630277.23707.132.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366630277.23707.132.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22/04/13 12:31, joeyli wrote:
> Does garbage collection only trigger by UEFI BIOS when system reboot? or
> garbage collection also triggered at run time?

That is implementation specific. AFAIK, there are implementations for
both schemes.

-- 
Matt Fleming, Intel Open Source Technology Center
