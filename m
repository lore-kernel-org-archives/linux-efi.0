From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [Bug Report] kdump crashes after latest EFI memblock changes on
 arm64 machines with large number of CPUs
Date: Mon, 5 Nov 2018 11:31:37 +0000
Message-ID: <f5c4c03a-e88f-ea42-b791-e50808e8247b@arm.com>
References: <CACi5LpOyy0YkhEzWWqt8hAQfKku2Vzp5+da_dGS23JMyHReNew@mail.gmail.com>
 <CAKv+Gu_1PNiGbgRqd3_0k6CGzh-2P+iAmqk=oSSek69kBCnb8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <CAKv+Gu_1PNiGbgRqd3_0k6CGzh-2P+iAmqk=oSSek69kBCnb8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kexec mailing list <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/11/18 11:11, Ard Biesheuvel wrote:
> (+ Marc)
> 
> On 1 November 2018 at 22:14, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Hi,
>>
>> With the latest EFI changes for memblock reservation across kdump
>> kernel from Ard (Commit 71e0940d52e107748b270213a01d3b1546657d74
>> ["efi: honour memory reservations passed via a linux specific config
>> table"]), we hit a panic while trying to boot the kdump kernel on
>> machines which have large number of CPUs.
>>
> 
> Just for my understanding: why do you boot all 224 CPus when running
> the crash kernel?

FWIW, I've used these patches to kexec a kernel on a 256 CPUs system,
without any issue. Why am I not seeing this problem?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
