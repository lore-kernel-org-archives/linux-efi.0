From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Thu, 13 Sep 2018 22:48:03 +0300
Message-ID: <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
References: <20180911161527.GA30689@vnote> <20180912083844.iegei2kobcz4b7ag@ws.net.home>
 <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David.Laight@aculab.com
Cc: kzak@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> I suspect you also need a sanity check that the value isn't too small
> or stupidly large.

What would be the criterion for too large entries?

-- 
Eugene
