From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/arm64: handle randomized TEXT_OFFSET
Date: Tue, 24 Apr 2018 12:13:23 +0100
Message-ID: <20180424111323.ifqq7hathc3n54ne@lakrids.cambridge.arm.com>
References: <20180424110058.29344-1-mark.rutland@arm.com>
 <CAKv+Gu813jnf1RPU0HKMXapeK04XhJMveeLb9uppx7recyUW5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu813jnf1RPU0HKMXapeK04XhJMveeLb9uppx7recyUW5w@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Kim Phillips <kim.phillips@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 24, 2018 at 01:11:40PM +0200, Ard Biesheuvel wrote:
> Hi Mark,
> 
> On 24 April 2018 at 13:00, Mark Rutland <mark.rutland@arm.com> wrote:
> > When CONFIG_RANDOMIZE_TEXT_OFFSET is selected, TEXT_OFFSET is an
> > arbitrary multiple of PAGE_SIZE in the interval [0, 2MB).
> >
> > The EFI stub doesn't accuont for this, and only handles the case where
> 
> 'account'
> 
> If you agree, I will add something here to clarify that the newly
> chosen offset should retain the misalignment of TEXT_OFFSET relative
> to EFI_KIMG_ALIGN, because it took me a while to figure that out.

That makes sense to me. Sorry for the clumsy wording!

> 
> Other than that,
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> I will queue this as a fix

Great; thanks!

Mark.
