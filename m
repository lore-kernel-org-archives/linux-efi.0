From: josh@joshtriplett.org
Subject: Re: Running Sparse twice on TOT produce the different set of
 warnings and error.!!
Date: Wed, 12 Nov 2014 11:06:21 -0800
Message-ID: <20141112190621.GA21251@cloud>
References: <CAHK0xLu1rPGnCLZQDtjU1n_erjPJL9j-+WkZgpTPqvgc181e4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-sparse-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHK0xLu1rPGnCLZQDtjU1n_erjPJL9j-+WkZgpTPqvgc181e4w@mail.gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
To: Amit Sharma <amit.rinku.sharma072@gmail.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 12, 2014 at 11:54:09PM +0530, Amit Sharma wrote:
> I just started to use the sparse and I was suppose to do some
> regression testing using sparse tool. What I observed during using of
> sparse is that it produces the different set of warnings and errors
> when we ran it twice on TOT without modifying anything in-between
> succession run of sparse. I just want to know is this is the known
> issue(Bug) of sparse ? If yes, can someone share here ?

Can you provide a sample of the differences?

How did you invoke Sparse?  C=1 or C=2?

- Josh Triplett
