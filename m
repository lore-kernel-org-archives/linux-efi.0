From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
Date: Tue, 10 Dec 2013 15:38:01 -0800
Message-ID: <52A7A5D9.9030504@zytor.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com> <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org> <20131210233207.GI31437@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131210233207.GI31437-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/10/2013 03:32 PM, Borislav Petkov wrote:
> On Tue, Dec 10, 2013 at 03:25:49PM -0800, Andrew Morton wrote:
>> On Mon,  9 Dec 2013 17:42:13 +0800 Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>> Here is the V5 patchset for supporting kexec kernel efi runtime.
>>
>> It's unclear (to me) who's supposed to merge this lot.  It's a "kexec"
>> patch which actually hits on efi and x86.
>>
>> I grabbed them for some -next testing but won't be offended if someone
>> else merges them ;)
> 
> I was under the impression that this should go through Matt's efi tree.
> Oh, and we need to finish reviewing them so picking them up now would be
> too premature, IMHO.
> 

My intent was to pick them into a separate branch of the tip tree either
directly or via Matt (since Matt feeds us anyway.)

But yes, work is still underway, although it is getting there.

	-hpa
