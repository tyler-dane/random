import gpt_2_simple as gpt2

model_size = "774M"

gpt2.download_gpt2(model_name=model_size)
sess = gpt2.start_tf_sess()
gpt2.load_gpt2(sess, model_name=model_size)

gpt2.generate(
    sess,
    model_name=model_size,
    prefix = "The meaning of life is ",
    length = 100,
    temperature = 0.7,
    top_p = 0.9,
    nsamples = 1,
    batch_size = 1
)
