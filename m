From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 09 Sep 2013 12:41:59 -0700
Message-ID: <522E2487.90109@zytor.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu>            <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz> <27562.1378753264@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27562.1378753264-+bZmOdGhbsPr6rcHtW+onFJE71vCis6O@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Cc: David Lang <david-gFPdbfVZQbY@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/09/2013 12:01 PM, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org wrote:
> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
> 
>> Given that we know that people want signed binaries without
>> blocking kexec, you should have '1' just enforce module signing
>> and '2' (or higher) implement a full lockdown including kexec.
> 
>> Or, eliminate the -1  permanently insecure option and make this a
>> bitmask, if someone wants to enable every possible lockdown, have
>> them set it to "all 1's", define the bits only as you need them.
> 
> This strikes me as much more workable than one big sledgehammer.
> 

I.e. capabilities ;)

	-hpa
