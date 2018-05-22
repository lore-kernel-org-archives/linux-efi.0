From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V3 2/3] efi: Introduce efi_queue_work() to queue any
 efi_runtime_service() on efi_rts_wq
Date: Tue, 22 May 2018 22:44:46 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F392AE61C@ORSMSX114.amr.corp.intel.com>
References: <1526958784-14688-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1526958784-14688-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180522073618.GN12198@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522073618.GN12198@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

> On Mon, May 21, 2018 at 08:13:03PM -0700, Sai Praneeth Prakhya wrote:
> > +	/*								\
> > +	 * queue_work() returns 0 if work was already on queue,         \
> > +	 * _ideally_ this should never happen.                          \
> > +	 */								\
> > +	if (queue_work(efi_rts_wq, &efi_rts_work.work))
> 	\
> > +		flush_work(&efi_rts_work.work);
> 	\
> 
> Since you're _always_ going to wait for it, it is _much_ cheaper to put a
> completion in your actual work and wait for that.

Sure! I will change it.
I also noticed that flush_work() in turn calls wait_for_completion().

Will also wait for a couple of days before posting V4.

Regards,
Sai
